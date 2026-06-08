using Microsoft.AspNetCore.Mvc;
using STEMMA.Application.Consultas.DTOs.Requests;
using STEMMA.Application.Consultas.UseCases;

namespace STEMMA.Api.Controllers.Consultas;

[ApiController]
[Route("api/[controller]")]
public class ConsultaController : ControllerBase
{
    private readonly CreateConsultationUseCase _createConsultationUseCase;
    private readonly UpdateConsultationUseCase _updateConsultationUseCase;
    private readonly CancelConsultationUseCase _cancelConsultationUseCase;
    private readonly CompleteConsultationUseCase _completeConsultationUseCase;
    private readonly AddMedicalRecordUseCase _addMedicalRecordUseCase;
    private readonly GetConsultationByIdUseCase _getConsultationByIdUseCase;
    private readonly ListConsultationsUseCase _listConsultationsUseCase;
    private readonly ListConsultationsByPetUseCase _listByPetUseCase;
    private readonly StartConsultationUseCase _startConsultationUseCase;
    private readonly ListClosedConsultationsUseCase _listClosedConsultationsUseCase;

    public ConsultaController(
        CreateConsultationUseCase createConsultationUseCase,
        UpdateConsultationUseCase updateConsultationUseCase,
        CancelConsultationUseCase cancelConsultationUseCase,
        CompleteConsultationUseCase completeConsultationUseCase,
        AddMedicalRecordUseCase addMedicalRecordUseCase,
        GetConsultationByIdUseCase getConsultationByIdUseCase,
        ListConsultationsUseCase listConsultationsUseCase,
        ListConsultationsByPetUseCase listByPetUseCase,
        StartConsultationUseCase startConsultationUseCase,
        ListClosedConsultationsUseCase listClosedConsultationsUseCase)
    {
        _createConsultationUseCase = createConsultationUseCase;
        _updateConsultationUseCase = updateConsultationUseCase;
        _cancelConsultationUseCase = cancelConsultationUseCase;
        _completeConsultationUseCase = completeConsultationUseCase;
        _addMedicalRecordUseCase = addMedicalRecordUseCase;
        _getConsultationByIdUseCase = getConsultationByIdUseCase;
        _listConsultationsUseCase = listConsultationsUseCase;
        _listByPetUseCase = listByPetUseCase;
        _startConsultationUseCase = startConsultationUseCase;
        _listClosedConsultationsUseCase = listClosedConsultationsUseCase;
    }

    [HttpPost]
    public async Task<IActionResult> Create(
        [FromBody] CreateConsultationRequest request)
    {
        try
        {
            await _createConsultationUseCase.ExecuteAsync(request);

            return Ok();
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [HttpPost("{id:guid}/start")]
    public async Task<IActionResult> Start(Guid id)
    {
        try
        {
            await _startConsultationUseCase.ExecuteAsync(id);

            return NoContent();
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> Update(
        Guid id,
        [FromBody] UpdateConsultationRequest request)
    {
        await _updateConsultationUseCase.ExecuteAsync(id, request);

        return NoContent();
    }

    [HttpPost("cancel")]
    public async Task<IActionResult> Cancel(
        [FromBody] CancelConsultationRequest request)
    {
        await _cancelConsultationUseCase.ExecuteAsync(request);

        return NoContent();
    }

    [HttpPost("{id:guid}/complete")]
    public async Task<IActionResult> Complete(Guid id)
    {
        try
        {
            await _completeConsultationUseCase.ExecuteAsync(id);

            return NoContent();
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [HttpPost("medical-record")]
    public async Task<IActionResult> AddMedicalRecord(
        [FromBody] AddMedicalRecordRequest request)
    {
        try
        {
            await _addMedicalRecordUseCase.ExecuteAsync(request);

            return NoContent();
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var consultation =
            await _getConsultationByIdUseCase.ExecuteAsync(id);

        if (consultation is null)
            return NotFound();

        return Ok(consultation);
    }

    [HttpGet]
    public async Task<IActionResult> List()
    {
        var consultations =
            await _listConsultationsUseCase.ExecuteAsync();

        return Ok(consultations);
    }

    [HttpGet("historico-pet/{petId:guid}")]
    public async Task<IActionResult> ListarHistoricoPorPet(Guid petId)
    {
        var consultas =
            await _listByPetUseCase.ExecuteAsync(petId);

        return Ok(consultas);
    }

    [HttpGet("encerradas")]
    public async Task<IActionResult> ListarEncerradas()
    {
        var consultas =
            await _listClosedConsultationsUseCase.ExecuteAsync();

        return Ok(consultas);
    }
}