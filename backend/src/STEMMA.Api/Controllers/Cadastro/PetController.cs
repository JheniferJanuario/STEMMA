using Microsoft.AspNetCore.Mvc;
using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.UseCases.Pet;
using STEMMA.Application.Cadastro.UseCases.Pets;

namespace STEMMA.API.Controllers;

[ApiController]
[Route("api/pets")]
public class PetController : ControllerBase
{
    private readonly CreatePetUseCase _createPetUseCase;
    private readonly UpdatePetUseCase _updatePetUseCase;
    private readonly InactivatePetUseCase _inactivatePetUseCase;
    private readonly GetPetByIdUseCase _getPetByIdUseCase;
    private readonly ListPetsUseCase _listPetsUseCase;

    public PetController(
        CreatePetUseCase createPetUseCase,
        UpdatePetUseCase updatePetUseCase,
        InactivatePetUseCase inactivatePetUseCase,
        GetPetByIdUseCase getPetByIdUseCase,
        ListPetsUseCase listPetsUseCase)
    {
        _createPetUseCase = createPetUseCase;
        _updatePetUseCase = updatePetUseCase;
        _inactivatePetUseCase = inactivatePetUseCase;
        _getPetByIdUseCase = getPetByIdUseCase;
        _listPetsUseCase = listPetsUseCase;
    }

    // CREATE
    [HttpPost]
    public async Task<IActionResult> Create(CreatePetRequest request)
    {
        var result = await _createPetUseCase.ExecuteAsync(request);
        return CreatedAtAction(nameof(GetById), new { id = result.Id }, result);
    }

    // UPDATE
    [HttpPut("{id}")]
    public async Task<IActionResult> Update(Guid id, UpdatePetRequest request)
    {
        var result = await _updatePetUseCase.ExecuteAsync(id, request);
        return Ok(result);
    }

    // INACTIVATE
    [HttpDelete("{id}")]
    public async Task<IActionResult> Inactivate(Guid id)
    {
        await _inactivatePetUseCase.ExecuteAsync(id);
        return NoContent();
    }

    // GET BY ID
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var result = await _getPetByIdUseCase.ExecuteAsync(id);
        return Ok(result);
    }

    // LIST
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var result = await _listPetsUseCase.ExecuteAsync();
        return Ok(result);
    }
}