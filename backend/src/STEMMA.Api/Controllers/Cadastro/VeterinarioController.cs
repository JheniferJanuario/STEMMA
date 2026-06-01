using Microsoft.AspNetCore.Mvc;
using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.Veterinarios.DTOs.Requests;
using STEMMA.Application.Cadastro.Veterinarios.Services;

namespace STEMMA.Api.Controllers.Cadastro;

[ApiController]
[Route("api/[controller]")]
public class VeterinarioController : ControllerBase
{
    private readonly IVeterinarioService _veterinarioService;

    public VeterinarioController(
        IVeterinarioService veterinarioService)
    {
        _veterinarioService = veterinarioService;
    }

    [HttpPost]
    public async Task<IActionResult> Criar(
        [FromBody] CreateVeterinarioRequest request)
    {
        var id = await _veterinarioService.CriarAsync(request);

        return CreatedAtAction(
            nameof(ObterPorId),
            new { id },
            id);
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> ObterPorId(Guid id)
    {
        var veterinario =
            await _veterinarioService.ObterPorIdAsync(id);

        return Ok(veterinario);
    }

    [HttpGet]
    public async Task<IActionResult> Listar()
    {
        var veterinarios =
            await _veterinarioService.ListarAsync();

        return Ok(veterinarios);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> Atualizar(
        Guid id,
        [FromBody] UpdateVeterinarioRequest request)
    {
        var veterinario =
            await _veterinarioService.AtualizarAsync(id, request);

        return Ok(veterinario);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Remover(Guid id)
    {
        await _veterinarioService.RemoverAsync(id);

        return NoContent();
    }
}