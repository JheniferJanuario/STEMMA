using STEMMA.Domain.Cadastro.Entities;

namespace STEMMA.Domain.Cadastro.Repositories;

public interface IVeterinarioRepository
{
    Task AdicionarAsync(Veterinario veterinario);

    Task AtualizarAsync(Veterinario veterinario);
    Task RemoverAsync(Guid id);
    Task<Veterinario?> ObterPorIdAsync(Guid id);
    Task<Veterinario?> ObterPorCRMVAsync(string crmv);
    Task<Veterinario?> ObterPorEmailAsync(string email);
    Task<List<Veterinario>> ListarAsync();
}