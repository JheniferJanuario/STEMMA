using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Application.Consultas.UseCases;

public class StartConsultationUseCase
{
    private readonly IConsultaRepository _consultaRepository;

    public StartConsultationUseCase(
        IConsultaRepository consultaRepository)
    {
        _consultaRepository = consultaRepository;
    }

    public async Task ExecuteAsync(Guid id)
    {
        var consulta =
            await _consultaRepository.ObterPorIdAsync(id);

        if (consulta is null)
            throw new Exception("Consulta não encontrada.");

        consulta.Iniciar();

        await _consultaRepository.AtualizarAsync(consulta);
    }
}