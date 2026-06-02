using STEMMA.Domain.Consultas.Entities;
using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Infrastructure.Persistence.Repositories;

public class DisponibilidadeRepository : IDisponibilidadeRepository
{
    public Task AdicionarAsync(Disponibilidade disponibilidade)
    {
        throw new NotImplementedException();
    }

    public Task AtualizarAsync(Disponibilidade disponibilidade)
    {
        throw new NotImplementedException();
    }

    public Task<bool> ExisteConflitoAsync(Guid veterinarioId, DateTime inicio, DateTime fim)
    {
        throw new NotImplementedException();
    }

    public Task<List<Disponibilidade>> ListarAsync()
    {
        throw new NotImplementedException();
    }

    public Task<Disponibilidade?> ObterPorIdAsync(Guid id)
    {
        throw new NotImplementedException();
    }

    public Task<List<Disponibilidade>> ObterPorPeriodoAsync(Guid veterinarioId, DateTime inicio, DateTime fim)
    {
        throw new NotImplementedException();
    }

    public Task<List<Disponibilidade>> ObterPorVeterinarioAsync(Guid veterinarioId)
    {
        throw new NotImplementedException();
    }

    public Task RemoverAsync(Disponibilidade disponibilidade)
    {
        throw new NotImplementedException();
    }
}