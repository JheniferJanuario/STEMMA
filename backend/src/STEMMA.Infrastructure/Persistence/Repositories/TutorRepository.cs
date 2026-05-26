using Microsoft.EntityFrameworkCore;
using STEMMA.Domain.Cadastro.Entities;
using STEMMA.Domain.Cadastro.Repositories;
using STEMMA.Infrastructure.Persistence.Context;

namespace STEMMA.Infrastructure.Persistence.Repositories;

public class TutorRepository : ITutorRepository
{
    private readonly StemmaDbContext _context;

    public TutorRepository(StemmaDbContext context)
    {
        _context = context;
    }

    public async Task AdicionarAsync(Tutor tutor)
    {
        await _context.Tutores.AddAsync(tutor);

        await _context.SaveChangesAsync();
    }

    public async Task AtualizarAsync(Tutor tutor)
    {
        _context.Tutores.Update(tutor);

        await _context.SaveChangesAsync();
    }

    public async Task RemoverAsync(Guid id)
    {
        var tutor = await ObterPorIdAsync(id);

        if (tutor is null)
            return;

        _context.Tutores.Remove(tutor);

        await _context.SaveChangesAsync();
    }

    public async Task<Tutor?> ObterPorIdAsync(Guid id)
    {
        return await _context.Tutores
            .Include(x => x.Pets)
            .FirstOrDefaultAsync(x => x.Id == id);
    }

    public async Task<List<Tutor>> ListarAsync()
    {
        return await _context.Tutores
            .Include(x => x.Pets)
            .ToListAsync();
    }
}