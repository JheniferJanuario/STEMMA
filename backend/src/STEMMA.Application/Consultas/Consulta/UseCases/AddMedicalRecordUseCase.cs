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

        var prontuario = new Prontuario(
            request.ConsultationId,
            request.Description,
            request.Diagnostico
        );

        await _prontuarioRepository.AdicionarAsync(prontuario);
    }
}