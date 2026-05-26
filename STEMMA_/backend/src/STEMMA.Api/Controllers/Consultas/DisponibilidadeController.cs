using Microsoft.AspNetCore.Mvc;

namespace STEMMA.Api.Controllers.Consultas;

[ApiController]
[Route("api/disponibilidades")]
public class DisponibilidadeController : ControllerBase
{
    [HttpGet]
    public IActionResult Listar()
    {
        return Ok();
    }
}