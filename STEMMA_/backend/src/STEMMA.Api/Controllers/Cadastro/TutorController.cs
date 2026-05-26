using Microsoft.AspNetCore.Mvc;

namespace STEMMA.Api.Controllers.Cadastro;

[ApiController]
[Route("api/tutores")]
public class TutorController : ControllerBase
{
    [HttpGet]
    public IActionResult Listar()
    {
        return Ok(new[]
        {
            new { Id = 1, Nome = "João da Silva" }
        });
    }
}