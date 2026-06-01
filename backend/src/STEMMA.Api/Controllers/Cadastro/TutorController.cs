using Microsoft.AspNetCore.Mvc;
using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.Tutores.Services;

namespace STEMMA.Api.Controllers.Cadastro;

[ApiController]
[Route("api/[controller]")]
public class TutorController : ControllerBase
{
    private readonly ITutorService _tutorService;

    public TutorController(
        ITutorService tutorService)
    {
        _tutorService = tutorService;
    }

    [HttpPost]
    public async Task<IActionResult> Criar(
        [FromBody] CreateTutorRequest request)
    {
        var id = await _tutorService.CriarAsync(request);

        return CreatedAtAction(
            nameof(ObterPorId),
            new { id },
            id);
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> ObterPorId(Guid id)
    {
        var tutor = await _tutorService.ObterPorIdAsync(id);

        return Ok(tutor);
    }

    [HttpGet]
    public async Task<IActionResult> Listar()
    {
        var tutores = await _tutorService.ListarAsync();

        return Ok(tutores);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> Atualizar(
        Guid id,
        [FromBody] UpdateTutorRequest request)
    {
        var tutor = await _tutorService.AtualizarAsync(
            id,
            request);

        return Ok(tutor);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Remover(Guid id)
    {
        await _tutorService.RemoverAsync(id);

        return NoContent();
    }
}