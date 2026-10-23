from pathlib import Path
from fastapi import APIRouter, Request, HTTPException, status
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from fastapi.templating import Jinja2Templates

from .dto.diego_dto import DiegoBaseDTO
from .services.diego_service import DiegoService
from .diego_config import PAGES_DIR, SERVICES_DIR
from paths import STATIC_DIR, TEMPLATES_DIR

# Definimos el router
router = APIRouter(
    prefix="/diego",
    tags=["Diego"]
)

templates = Jinja2Templates(directory=[PAGES_DIR, TEMPLATES_DIR])

@router.get("/")
async def diego_page(request: Request):
    """
    Devuelve la página principal para el plugin Diego.
    """
    return templates.TemplateResponse(
        request=request,
        name="main.html"
    )


@router.get("/hello-world")
async def hello_world():
    result = DiegoService.get_hola_mundo()

    return {
        "message": result
    }


@router.post("/hello-name")
async def hello_name(data: DiegoBaseDTO):
    result = DiegoService.post_hola_nombre(data)

    return {
        "message": result
    }