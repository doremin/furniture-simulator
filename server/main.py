from fastapi import FastAPI
from fastapi.responses import FileResponse, PlainTextResponse

import os

app = FastAPI()

model_dir_path = "./models"

ext_to_keyname = {
    ".obj": "model",
    ".png": "thumbnail"
}

@app.get("/model")
async def models():
    files = os.listdir(model_dir_path)
    return files

@app.get("/model/{model_name}")
async def model_info(model_name: str):
    response = {}

    files = os.listdir(f"{model_dir_path}/{model_name}")
    for file in files:
        _, ext = os.path.splitext(file)
        ext_to_keyname[ext]: file
        
    return response

@app.get("/model/{model_name}/{file_name}")
async def send_file(model_name: str, file_name: str):
    file_path = f"{model_dir_path}/{model_name}/{file_name}"

    return FileResponse(path=file_path)

@app.exception_handler(RuntimeError)
async def runtime_error_handler(_, exc):
    return PlainTextResponse(f"exception: {exc}", status_code=400)
