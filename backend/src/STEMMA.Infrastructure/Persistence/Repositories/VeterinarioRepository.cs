using Microsoft.EntityFrameworkCore;
using STEMMA.Domain.Cadastro.Entities;
using STEMMA.Domain.Cadastro.Repositories;
using STEMMA.Infrastructure.Persistence.Context;

namespace STEMMA.Infrastructure.Persistence.Repositories;

public class VeterinarioRepository : IVeterinarioRepository
{
    private readonly StemmaDbContext _context;

    public VeterinarioRepository(StemmaDbContext context)
    {
        _context = context;
    }

    public async Task AdicionarAsync(
        Veterinario veterinario)
    {
        await _context.Set<Veterinario>()
            .AddAsync(veterinario);

        await _context.SaveChangesAsync();
    }

    public async Task AtualizarAsync(
        Veterinario veterinario)
    {
        _context.Set<Veterinario>()
            .Update(veterinario);

        await _context.SaveChangesAsync();
    }

    public async Task RemoverAsync(Guid id)
    {
        var veterinario =
            await ObterPorIdAsync(id);

        if (veterinario is null)
            return;

        _context.Set<Veterinario>()
            .Remove(veterinario);

        await _context.SaveChangesAsync();
    }

    public async Task<Veterinario?> ObterPorIdAsync(
        Guid id)
    {
        return await _context.Set<Veterinario>()
            .FirstOrDefaultAsync(x => x.Id == id);
    }

    public async Task<Veterinario?> ObterPorCRMVAsync(
        string crmv)
    {
        return await _context.Set<Veterinario>()
            .FirstOrDefaultAsync(x => x.CRMV == crmv);
    }

    public async Task<Veterinario?> ObterPorEmailAsync(
    string email)
    {
        return await _context.Set<Veterinario>()
            .FirstOrDefaultAsync(x => x.Email == email);
    }

    public async Task<List<Veterinario>> ListarAsync()
    {
        return await _context.Set<Veterinario>()
            .ToListAsync();
    }
}