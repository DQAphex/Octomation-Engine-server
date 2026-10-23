from ..dto.diego_dto import DiegoBaseDTO


class DiegoService:

    def __init__(self, metadata: DiegoBaseDTO):
        self.metadata = metadata

    @staticmethod
    def get_hola_mundo() -> str:
        return "Hola mundo"

    @staticmethod
    def post_hola_nombre(
        data: DiegoBaseDTO
    ) -> str:
        return f"Hola {data.nombre}"