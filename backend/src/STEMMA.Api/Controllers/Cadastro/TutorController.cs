using Microsoft.AspNetCore.Mvc;
using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.UseCases.Tutor;

namespace STEMMA.Api.Controllers;

[ApiController]
[Route("api/tutor")]
public class TutorController : ControllerBase
{
    private readonly CreateTutorUseCase _useCase;

    public TutorController(CreateTutorUseCase useCase)
    {
        _useCase = useCase;
    }

    [HttpPost]
    public async Task<IActionResult> Create(CreateTutorRequest request)
    {
        var id = await _useCase.Execute(request.Nome, request.Email);
        return Ok(id);
    }
}