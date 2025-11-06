from fastapi import FastAPI, File, UploadFile, Form
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from PIL import Image
import io
import uvicorn
import numpy as np

# Transformers (CLIP) -> zero-shot classification
from transformers import CLIPProcessor, CLIPModel
import torch

app = FastAPI(title="CaloriaFoto - Inference (MVP)")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

print("Carregando modelo CLIP... isso pode demorar na primeira vez.")
device = "cuda" if torch.cuda.is_available() else "cpu"
model = CLIPModel.from_pretrained("openai/clip-vit-base-patch32")
processor = CLIPProcessor.from_pretrained("openai/clip-vit-base-patch32")
model.to(device)
model.eval()
print("Modelo carregado em", device)

NUTRITION_DB = {
    "Arroz branco": {"portion_g": 150, "kcal_per_100g": 137},
    "Feijão": {"portion_g": 100, "kcal_per_100g": 76},
    "Frango grelhado": {"portion_g": 120, "kcal_per_100g": 165},
    "Carne bovina (cozida)": {"portion_g": 120, "kcal_per_100g": 250},
    "Banana": {"portion_g": 100, "kcal_per_100g": 89},
    "Maçã": {"portion_g": 100, "kcal_per_100g": 52},
    "Batata frita": {"portion_g": 100, "kcal_per_100g": 312},
    "Salada (mix)": {"portion_g": 80, "kcal_per_100g": 15},
    "Ovo cozido": {"portion_g": 50, "kcal_per_100g": 155},
    "Pão francês": {"portion_g": 50, "kcal_per_100g": 265},
    "Peixe grelhado": {"portion_g": 120, "kcal_per_100g": 206},
    "Pizza (fatia média)": {"portion_g": 120, "kcal_per_100g": 266},
}

CANDIDATE_LABELS = list(NUTRITION_DB.keys())

def estimate_kcal(label: str, portion_g: float = None):
    info = NUTRITION_DB.get(label)
    if not info:
        return None
    p = portion_g if portion_g is not None else info["portion_g"]
    kcal100 = info["kcal_per_100g"]
    kcal = (p * kcal100) / 100.0
    return {"portion_g": p, "kcal": round(kcal, 1)}

def run_clip_zero_shot(image: Image.Image, candidate_labels, top_k=3):
    inputs = processor(text=candidate_labels, images=image, return_tensors="pt", padding=True)
    inputs = {k: v.to(device) for k, v in inputs.items()}
    with torch.no_grad():
        outputs = model(**inputs)
        logits_per_image = outputs.logits_per_image
        probs = logits_per_image.softmax(dim=1)

    probs = probs.cpu().numpy()[0]
    idxs = np.argsort(-probs)[:top_k]
    results = []
    for i in idxs:
        label = candidate_labels[int(i)]
        conf = float(probs[int(i)])
        results.append({"label": label, "confidence": round(conf, 4)})
    return results

@app.post("/api/infer")
async def infer(photo: UploadFile = File(...), portion_multiplier: float = Form(1.0)):
    try:
        contents = await photo.read()
        image = Image.open(io.BytesIO(contents)).convert("RGB")
    except Exception as e:
        return JSONResponse({"error": "Imagem inválida: " + str(e)}, status_code=400)

    top = run_clip_zero_shot(image, CANDIDATE_LABELS, top_k=5)

    items = []
    total_kcal = 0.0
    for r in top:
        est = estimate_kcal(r["label"])
        if est is None:
            continue
        est_portion = round(est["portion_g"] * float(portion_multiplier), 1)
        est_kcal = round((est["kcal"] * float(portion_multiplier)), 1)
        items.append({
            "name": r["label"],
            "confidence": r["confidence"],
            "portion_g": est_portion,
            "kcal": est_kcal
        })
        total_kcal += est_kcal

    response = {
        "items": items,
        "total_kcal": round(total_kcal, 1),
        "note": "MVP: inferência usando CLIP zero-shot + base nutricional simplificada. Para maior precisão, integrar detector/segmentador e pedir referência de escala."
    }
    return JSONResponse(response)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
