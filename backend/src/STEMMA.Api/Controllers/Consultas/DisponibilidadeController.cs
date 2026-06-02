using Microsoft.AspNetCore.Mvc;
using STEMMA.Application.Consultas.Disponibilidades.DTOs.Requests;
using STEMMA.Application.Consultas.Disponibilidades.UseCases;


namespace STEMMA.Api.Controllers.Consultas;

[ApiController]
[Route("api/[controller]")]
public class DisponibilidadeController : ControllerBase
{
    private readonly CreateDisponibilidadeUseCase _createUseCase;
    private readonly ListDisponibilidadesUseCase _listUseCase;
    private readonly ListDisponibilidadesPorVeterinarioUseCase _listPorVeterinarioUseCase;
    private readonly DeleteDisponibilidadeUseCase _deleteUseCase;
    private readonly ListHorariosDisponiveisUseCase _listHorariosDisponiveisUseCase;
    private readonly CreateAgendaDisponibilidadeUseCase _createAgendaUseCase;

    public DisponibilidadeController(
        CreateDisponibilidadeUseCase createUseCase,
        ListDisponibilidadesUseCase listUseCase,
        ListDisponibilidadesPorVeterinarioUseCase listPorVeterinarioUseCase,
        DeleteDisponibilidadeUseCase deleteUseCase,
        ListHorariosDisponiveisUseCase listHorariosDisponiveisUseCase,
        CreateAgendaDisponibilidadeUseCase createAgendaUseCase)
    {
        _createUseCase = createUseCase;
        _listUseCase = listUseCase;
        _listPorVeterinarioUseCase = listPorVeterinarioUseCase;
        _deleteUseCase = deleteUseCase;
        _listHorariosDisponiveisUseCase = listHorariosDisponiveisUseCase;
        _createAgendaUseCase = createAgendaUseCase;
    }

    [HttpPost]
    public async Task<IActionResult> Criar(
    [FromBody] CreateDisponibilidadeRequest request)
    {
        try
        {
            var id = await _createUseCase.ExecuteAsync(request);

            return Ok(id);
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [HttpPost("agenda")]
    public async Task<IActionResult> CriarAgenda(
    [FromBody] CreateAgendaDisponibilidadeRequest request)
    {
        try
        {
            await _createAgendaUseCase.ExecuteAsync(request);

            return Ok("Agenda criada com sucesso.");
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [HttpGet]
    public async Task<IActionResult> Listar()
    {
        var disponibilidades =
            await _listUseCase.ExecuteAsync();

        return Ok(disponibilidades);
    }

    [HttpGet("veterinario/{veterinarioId:guid}")]
    public async Task<IActionResult> ListarPorVeterinario(
        Guid veterinarioId)
    {
        var disponibilidades =
            await _listPorVeterinarioUseCase.ExecuteAsync(
                veterinarioId);

        return Ok(disponibilidades);
    }

    [HttpGet("horarios-disponiveis")]
    public async Task<IActionResult> ListarHorariosDisponiveis(
    [FromQuery] Guid veterinarioId,
    [FromQuery] DateTime data)
    {
        var horarios =
            await _listHorariosDisponiveisUseCase.ExecuteAsync(
                veterinarioId,
                data);

        return Ok(horarios);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Remover(Guid id)
    {
        await _deleteUseCase.ExecuteAsync(id);

        return NoContent();
    }
}