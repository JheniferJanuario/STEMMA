using STEMMA.Domain.Consultas.Entities;

namespace STEMMA.Domain.Consultas.Repositories;

public interface IDisponibilidadeRepository
{
    Task AdicionarAsync(Disponibilidade disponibilidade);

    Task AtualizarAsync(Disponibilidade disponibilidade);

    Task RemoverAsync(Disponibilidade disponibilidade);

    Task<Disponibilidade?> ObterPorIdAsync(Guid id);

    Task<List<Disponibilidade>> ListarAsync();

    Task<List<Disponibilidade>> ObterPorVeterinarioAsync(Guid veterinarioId);

    Task<List<Disponibilidade>> ObterPorPeriodoAsync(
        Guid veterinarioId,
        DateTime inicio,
        DateTime fim);

    Task<bool> ExisteConflitoAsync(
        Guid veterinarioId,
        DateTime inicio,
        DateTime fim);
}