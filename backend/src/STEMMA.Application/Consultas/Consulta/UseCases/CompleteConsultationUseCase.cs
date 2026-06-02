using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Application.Consultas.UseCases;

public class CompleteConsultationUseCase
{
    private readonly IConsultaRepository _consultaRepository;

    public CompleteConsultationUseCase(IConsultaRepository consultaRepository)
    {
        _consultaRepository = consultaRepository;
    }

    public async Task ExecuteAsync(Guid consultationId)
    {
        var consulta = await _consultaRepository.ObterPorIdAsync(consultationId);

        if (consulta is null)
            throw new Exception("Consulta não encontrada");

        consulta.Concluir();

        await _consultaRepository.AtualizarAsync(consulta);
    }
}