using STEMMA.Domain.Cadastro.Entities;

namespace STEMMA.Domain.Cadastro.Repositories;

public interface IVeterinarioRepository
{
    Task AdicionarAsync(Veterinario veterinario);

    Task AtualizarAsync(Veterinario veterinario);

    Task<Veterinario?> ObterPorIdAsync(Guid id);

    Task<Veterinario?> ObterPorCRMVAsync(string crmv);

    Task<List<Veterinario>> ListarAsync();
}