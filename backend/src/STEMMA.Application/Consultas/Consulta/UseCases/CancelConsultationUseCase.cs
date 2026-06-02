using STEMMA.Domain.Consultas.Repositories;
using STEMMA.Application.Consultas.DTOs.Requests;

namespace STEMMA.Application.Consultas.UseCases;

public class CancelConsultationUseCase
{
    private readonly IConsultaRepository _consultaRepository;

    public CancelConsultationUseCase(IConsultaRepository consultaRepository)
    {
        _consultaRepository = consultaRepository;
    }

    public async Task ExecuteAsync(CancelConsultationRequest request)
    {
        var consulta = await _consultaRepository.ObterPorIdAsync(request.ConsultationId);

        if (consulta is null)
            throw new Exception("Consulta não encontrada");

        consulta.Cancelar();

        await _consultaRepository.AtualizarAsync(consulta);
    }
}