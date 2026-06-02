using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Application.Consultas.Disponibilidades.UseCases;

public class DeleteDisponibilidadeUseCase
{
    private readonly IDisponibilidadeRepository _repository;

    public DeleteDisponibilidadeUseCase(
        IDisponibilidadeRepository repository)
    {
        _repository = repository;
    }

    public async Task ExecuteAsync(Guid id)
    {
        var disponibilidade =
            await _repository.ObterPorIdAsync(id);

        if (disponibilidade is null)
            throw new Exception(
                "Disponibilidade não encontrada.");

        await _repository.RemoverAsync(disponibilidade);
    }
}