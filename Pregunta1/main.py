from fastapi import FastAPI, HTTPException
import requests
import csv

app = FastAPI()

API_URL = "https://api.example.com/books"

@app.get("/total_libros")
def obtener_total_libros():
    response = requests.get(API_URL)
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail="Error al obtener datos de la API")
    
    libros = response.json()
    total_libros = len(libros)
    return {"total_libros": total_libros}

@app.get("/guardar_libros")
def guardar_libros_en_csv():
    response = requests.get(API_URL)
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail="Error al obtener datos de la API")
    
    libros = response.json()
    with open("libros.csv", mode="w", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(["id", "titulo", "autor", "fecha_publicacion"])
        for libro in libros:
            writer.writerow([libro["id"], libro["title"], libro["author"], libro["published_date"]])
    
    return {"detalle": "Datos de los libros guardados en libros.csv"}
