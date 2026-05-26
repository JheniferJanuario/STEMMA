using Microsoft.EntityFrameworkCore;
using STEMMA.Domain.Cadastro.Entities;
using STEMMA.Domain.Cadastro.Repositories;
using STEMMA.Infrastructure.Persistence.Context;

namespace STEMMA.Infrastructure.Persistence.Repositories;

public class PetRepository : IPetRepository
{
    private readonly StemmaDbContext _context;

    public PetRepository(StemmaDbContext context)
    {
        _context = context;
    }

    public async Task AdicionarAsync(Pet pet)
    {
        await _context.Pets.AddAsync(pet);

        await _context.SaveChangesAsync();
    }

    public async Task AtualizarAsync(Pet pet)
    {
        _context.Pets.Update(pet);

        await _context.SaveChangesAsync();
    }

    public async Task RemoverAsync(Guid id)
    {
        var pet = await ObterPorIdAsync(id);

        if (pet is null)
            return;

        _context.Pets.Remove(pet);

        await _context.SaveChangesAsync();
    }

    public async Task<Pet?> ObterPorIdAsync(Guid id)
    {
        return await _context.Pets
            .Include(x => x.Tutor)
            .FirstOrDefaultAsync(x => x.Id == id);
    }

    public async Task<List<Pet>> ListarAsync()
    {
        return await _context.Pets
            .Include(x => x.Tutor)
            .ToListAsync();
    }
}