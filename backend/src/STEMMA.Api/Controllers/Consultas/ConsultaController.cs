using Microsoft.AspNetCore.Mvc;
using STEMMA.Application.Consultas.DTOs.Requests;
using STEMMA.Application.Consultas.UseCases;

namespace STEMMA.API.Controllers;

[ApiController]
[Route("api/consultas")]
public class ConsultaController : ControllerBase
{
    private readonly CreateConsultationUseCase _createConsultationUseCase;
    private readonly UpdateConsultationUseCase _updateConsultationUseCase;
    private readonly AddMedicalRecordUseCase _addMedicalRecordUseCase;

    public ConsultaController(
        CreateConsultationUseCase createConsultationUseCase,
        UpdateConsultationUseCase updateConsultationUseCase,
        AddMedicalRecordUseCase addMedicalRecordUseCase)
    {
        _createConsultationUseCase = createConsultationUseCase;
        _updateConsultationUseCase = updateConsultationUseCase;
        _addMedicalRecordUseCase = addMedicalRecordUseCase;
    }

    // CREATE CONSULTA
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateConsultationRequest request)
    {
        await _createConsultationUseCase.ExecuteAsync(request);
        return Ok(new { message = "Consulta criada com sucesso" });
    }

    // UPDATE CONSULTA
    [HttpPut("{id:guid}")]
    public async Task<IActionResult> Update(
      Guid id,
      UpdateConsultationRequest request)
    {
        var result = await _updateConsultationUseCase.ExecuteAsync(id, request);

        return Ok(result);
    }
    // ADD PRONTUÁRIO
    [HttpPost("{id}/prontuario")]
    public async Task<IActionResult> AddMedicalRecord(Guid id, [FromBody] AddMedicalRecordRequest request)
    {
        if (id != request.ConsultationId)
            return BadRequest("Id da consulta inválido");

        await _addMedicalRecordUseCase.ExecuteAsync(request);
        return Ok(new { message = "Prontuário adicionado com sucesso" });
    }
}