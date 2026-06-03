using Microsoft.AspNetCore.Mvc;
using STEMMA.Application.Consultas.Prontuarios.UseCases;

namespace STEMMA.Api.Controllers.Consultas;

[ApiController]
[Route("api/prontuarios")]
public class ProntuarioController : ControllerBase
{
    private readonly GetProntuarioByConsultaIdUseCase _getUseCase;
    private readonly GetProntuariosByPetUseCase _getByPetUseCase;

    public ProntuarioController(
        GetProntuarioByConsultaIdUseCase getUseCase,
        GetProntuariosByPetUseCase getByPetUseCase)
    {
        _getUseCase = getUseCase;
        _getByPetUseCase = getByPetUseCase;
    }

    [HttpGet("{consultaId:guid}")]
    public async Task<IActionResult> ObterPorConsulta(Guid consultaId)
    {
        try
        {
            var prontuario =
                await _getUseCase.ExecuteAsync(consultaId);

            return Ok(prontuario);
        }
        catch (Exception ex)
        {
            return NotFound(ex.Message);
        }
    }

    [HttpGet("pet/{petId:guid}")]
    public async Task<IActionResult> ObterPorPet(Guid petId)
    {
        var prontuarios =
            await _getByPetUseCase.ExecuteAsync(petId);

        return Ok(prontuarios);
    }
}