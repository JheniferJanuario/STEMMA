using STEMMA.Domain.Cadastro.Entities;
using STEMMA.Domain.Consultas.Entities;

namespace STEMMA.Domain.Cadastro.Repositories;

public interface IPetRepository
{
    Task AdicionarAsync(Pet pet);

    Task AtualizarAsync(Pet pet);

    Task RemoverAsync(Guid id);

    Task<Pet?> ObterPorIdAsync(Guid id);

    Task<List<Pet>> ListarAsync();
    

}