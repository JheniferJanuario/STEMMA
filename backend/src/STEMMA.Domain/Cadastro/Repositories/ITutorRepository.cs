using STEMMA.Domain.Cadastro.Entities;

namespace STEMMA.Domain.Cadastro.Repositories;

public interface ITutorRepository
{
    Task AdicionarAsync(Tutor tutor);

    Task AtualizarAsync(Tutor tutor);

    Task RemoverAsync(Guid id);

    Task<Tutor?> ObterPorIdAsync(Guid id);

    Task<List<Tutor>> ListarAsync();
}