using STEMMA.Domain.Consultas.Entities;

namespace STEMMA.Domain.Consultas.Repositories;

public interface IDisponibilidadeRepository
{
    Task AdicionarAsync(Disponibilidade disponibilidade);

    Task<List<Disponibilidade>> ListarAsync();
}