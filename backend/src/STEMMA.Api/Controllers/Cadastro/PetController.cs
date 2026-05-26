using Microsoft.AspNetCore.Mvc;

namespace STEMMA.Api.Controllers.Cadastro;

[ApiController]
[Route("api/pets")]
public class PetController : ControllerBase
{
    [HttpGet]
    public IActionResult Listar()
    {
        return Ok(new[]
        {
            new { Id = 1, Nome = "Rex" }
        });
    }
}