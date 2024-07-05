FROM python:3.9-slim

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

EXPOSE 8001

ENV NAME api-usuarios

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8001"]
