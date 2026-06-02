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

    public ConsultaController(
        CreateConsultationUseCase createConsultationUseCase,
        UpdateConsultationUseCase updateConsultationUseCase,
        CancelConsultationUseCase cancelConsultationUseCase,
        CompleteConsultationUseCase completeConsultationUseCase,
        AddMedicalRecordUseCase addMedicalRecordUseCase,
        GetConsultationByIdUseCase getConsultationByIdUseCase,
        ListConsultationsUseCase listConsultationsUseCase)
    {
        _createConsultationUseCase = createConsultationUseCase;
        _updateConsultationUseCase = updateConsultationUseCase;
        _cancelConsultationUseCase = cancelConsultationUseCase;
        _completeConsultationUseCase = completeConsultationUseCase;
        _addMedicalRecordUseCase = addMedicalRecordUseCase;
        _getConsultationByIdUseCase = getConsultationByIdUseCase;
        _listConsultationsUseCase = listConsultationsUseCase;
    }

    [HttpPost]
    public async Task<IActionResult> Create(
        CreateConsultationRequest request)
    {
        await _createConsultationUseCase.ExecuteAsync(request);

        return Ok();
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> Update(
        Guid id,
        UpdateConsultationRequest request)
    {
        await _updateConsultationUseCase.ExecuteAsync(id, request);

        return NoContent();
    }

    [HttpPost("cancel")]
    public async Task<IActionResult> Cancel(
        CancelConsultationRequest request)
    {
        await _cancelConsultationUseCase.ExecuteAsync(request);

        return NoContent();
    }

    [HttpPost("{id:guid}/complete")]
    public async Task<IActionResult> Complete(Guid id)
    {
        await _completeConsultationUseCase.ExecuteAsync(id);

        return NoContent();
    }

    [HttpPost("medical-record")]
    public async Task<IActionResult> AddMedicalRecord(
        AddMedicalRecordRequest request)
    {
        await _addMedicalRecordUseCase.ExecuteAsync(request);

        return NoContent();
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var consultation = await _getConsultationByIdUseCase.ExecuteAsync(id);

        if (consultation is null)
            return NotFound();

        return Ok(consultation);
    }

    [HttpGet]
    public async Task<IActionResult> List()
    {
        var consultations = await _listConsultationsUseCase.ExecuteAsync();

        return Ok(consultations);
    }
}