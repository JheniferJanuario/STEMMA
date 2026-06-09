using Microsoft.AspNetCore.Mvc;
using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.Tutores.UseCases;

namespace STEMMA.Api.Controllers.Cadastro;

[ApiController]
[Route("api/tutores")]
public class TutorController : ControllerBase
{
    private readonly CreateTutorUseCase _createTutorUseCase;
    private readonly GetTutorByIdUseCase _getTutorByIdUseCase;
    private readonly ListTutorsUseCase _listTutorsUseCase;
    private readonly UpdateTutorUseCase _updateTutorUseCase;
    private readonly DeleteTutorUseCase _deleteTutorUseCase;

    public TutorController(
        CreateTutorUseCase createTutorUseCase,
        GetTutorByIdUseCase getTutorByIdUseCase,
        ListTutorsUseCase listTutorsUseCase,
        UpdateTutorUseCase updateTutorUseCase,
        DeleteTutorUseCase deleteTutorUseCase)
    {
        _createTutorUseCase = createTutorUseCase;
        _getTutorByIdUseCase = getTutorByIdUseCase;
        _listTutorsUseCase = listTutorsUseCase;
        _updateTutorUseCase = updateTutorUseCase;
        _deleteTutorUseCase = deleteTutorUseCase;
    }

    [HttpPost]
    public async Task<IActionResult> Create(
        [FromBody] CreateTutorRequest request)
    {
        var id = await _createTutorUseCase.ExecuteAsync(request);

        return CreatedAtAction(
            nameof(GetById),
            new { id },
            id);
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var tutor = await _getTutorByIdUseCase.ExecuteAsync(id);

        return Ok(tutor);
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var tutors = await _listTutorsUseCase.ExecuteAsync();

        return Ok(tutors);
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> Update(
        Guid id,
        [FromBody] UpdateTutorRequest request)
    {
        var tutor = await _updateTutorUseCase.ExecuteAsync(
            id,
            request);

        return Ok(tutor);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id)
    {
        await _deleteTutorUseCase.ExecuteAsync(id);

        return NoContent();
    }
}