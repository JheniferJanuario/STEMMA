using STEMMA.Domain.Consultas.Entities;

namespace STEMMA.Domain.Consultas.Repositories;

public interface IConsultaRepository
{
    Task AdicionarAsync(Consulta consulta);

    Task AtualizarAsync(Consulta consulta);

    Task<Consulta?> ObterPorIdAsync(Guid id);

    Task<List<Consulta>> ListarAsync();
}