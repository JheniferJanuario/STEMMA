using STEMMA.Domain.Consultas.Entities;

namespace STEMMA.Domain.Consultas.Repositories;

public interface IProntuarioRepository
{
    Task AdicionarAsync(Prontuario prontuario);

    Task<Prontuario?> ObterPorIdAsync(Guid id);

    Task<List<Prontuario>> ListarAsync();
}