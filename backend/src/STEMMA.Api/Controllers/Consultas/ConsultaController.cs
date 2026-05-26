using Microsoft.AspNetCore.Mvc;

namespace STEMMA.Api.Controllers.Consultas;

[ApiController]
[Route("api/consultas")]
public class ConsultaController : ControllerBase
{
    [HttpGet]
    public IActionResult Listar()
    {
        return Ok(new[]
        {
            new { Id = 1, Veterinario = "Carlos" }
        });
    }
}