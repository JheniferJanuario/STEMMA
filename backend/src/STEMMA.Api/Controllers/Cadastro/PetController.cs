using Microsoft.AspNetCore.Mvc;
using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.UseCases.CriarPet;

namespace STEMMA.Api.Controllers;

[ApiController]
[Route("api/pet")]
public class PetController : ControllerBase
{
    private readonly CreatePetUseCase _useCase;

    public PetController(CreatePetUseCase useCase)
    {
        _useCase = useCase;
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreatePetRequest request)
    {
        var id = await _useCase.Execute(
            request.Nome,
            request.Raca,
            request.Idade,
            request.Peso,
            request.TutorId
        );

        return Ok(id);
    }
}