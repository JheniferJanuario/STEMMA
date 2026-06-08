using STEMMA.Domain.Consultas.Entities;
using STEMMA.Domain.Consultas.Repositories;
using STEMMA.Application.Consultas.DTOs.Requests;

namespace STEMMA.Application.Consultas.UseCases;

public class AddMedicalRecordUseCase
{
    private readonly IProntuarioRepository _prontuarioRepository;
    private readonly IConsultaRepository _consultaRepository;

    public AddMedicalRecordUseCase(
        IProntuarioRepository prontuarioRepository,
        IConsultaRepository consultaRepository)
    {
        _prontuarioRepository = prontuarioRepository;
        _consultaRepository = consultaRepository;
    }

    public async Task ExecuteAsync(AddMedicalRecordRequest request)
    {
        var consulta = await _consultaRepository.ObterPorIdAsync(request.ConsultationId);

        if (consulta is null)
            throw new Exception("Consulta não encontrada");

        var observacoes = string.IsNullOrWhiteSpace(request.Description)
            ? "Prontuário registrado."
            : request.Description.Trim();

        var diagnostico = string.IsNullOrWhiteSpace(request.Diagnostico)
            ? observacoes
            : request.Diagnostico.Trim();

        var tratamento = request.Tratamento?.Trim() ?? string.Empty;
        var medicacao = request.Medicacao?.Trim() ?? string.Empty;

        var prontuario = new Prontuario(
            request.ConsultationId,
            observacoes,
            diagnostico,
            tratamento,
            medicacao,
            request.Peso);

        await _prontuarioRepository.AdicionarAsync(prontuario);
    }
}