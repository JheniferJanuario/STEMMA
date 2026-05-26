using Microsoft.AspNetCore.Mvc;

namespace STEMMA.Api.Controllers.Consultas;

[ApiController]
[Route("api/prontuarios")]
public class ProntuarioController : ControllerBase
{
    [HttpGet]
    public IActionResult Listar()
    {
        return Ok();
    }
}