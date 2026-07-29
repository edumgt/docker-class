import os

import httpx
from fastapi import FastAPI

app = FastAPI(title="AI Application Starter", version="0.1.0")


@app.get("/health")
async def health() -> dict[str, str]:
    """Return configured service addresses without requiring model availability."""
    return {
        "status": "ok",
        "ollama": os.getenv("OLLAMA_BASE_URL", "http://ollama:11434"),
        "qdrant": os.getenv("QDRANT_URL", "http://qdrant:6333"),
    }


@app.get("/models")
async def models() -> dict:
    """Proxy the local Ollama model list for a small integration smoke test."""
    base_url = os.getenv("OLLAMA_BASE_URL", "http://ollama:11434")
    async with httpx.AsyncClient(timeout=10) as client:
        response = await client.get(f"{base_url}/api/tags")
        response.raise_for_status()
        return response.json()
