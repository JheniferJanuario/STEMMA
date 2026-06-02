using Microsoft.AspNetCore.Mvc;
using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.Veterinarios.DTOs.Requests;
using STEMMA.Application.Cadastro.Veterinarios.UseCases;

namespace STEMMA.Api.Controllers.Cadastro;

[ApiController]
[Route("api/[controller]")]
public class VeterinarioController : ControllerBase
{
    private readonly CreateVeterinarioUseCase _createUseCase;
    private readonly GetVeterinarioByIdUseCase _getByIdUseCase;
    private readonly ListVeterinariosUseCase _listUseCase;
    private readonly UpdateVeterinarioUseCase _updateUseCase;
    private readonly DeleteVeterinarioUseCase _deleteUseCase;

    public VeterinarioController(
        CreateVeterinarioUseCase createUseCase,
        GetVeterinarioByIdUseCase getByIdUseCase,
        ListVeterinariosUseCase listUseCase,
        UpdateVeterinarioUseCase updateUseCase,
        DeleteVeterinarioUseCase deleteUseCase)
    {
        _createUseCase = createUseCase;
        _getByIdUseCase = getByIdUseCase;
        _listUseCase = listUseCase;
        _updateUseCase = updateUseCase;
        _deleteUseCase = deleteUseCase;
    }

    [HttpPost]
    public async Task<IActionResult> Criar(
        [FromBody] CreateVeterinarioRequest request)
    {
        var id = await _createUseCase.ExecuteAsync(request);

        return CreatedAtAction(
            nameof(ObterPorId),
            new { id },
            id);
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> ObterPorId(Guid id)
    {
        var veterinario = await _getByIdUseCase.ExecuteAsync(id);

        return Ok(veterinario);
    }

    [HttpGet]
    public async Task<IActionResult> Listar()
    {
        var veterinarios = await _listUseCase.ExecuteAsync();

        return Ok(veterinarios);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> Atualizar(
        Guid id,
        [FromBody] UpdateVeterinarioRequest request)
    {
        var veterinario = await _updateUseCase.ExecuteAsync(id, request);

        return Ok(veterinario);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Remover(Guid id)
    {
        await _deleteUseCase.ExecuteAsync(id);

        return NoContent();
    }
}