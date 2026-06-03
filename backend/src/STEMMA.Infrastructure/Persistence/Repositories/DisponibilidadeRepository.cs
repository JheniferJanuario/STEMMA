using Microsoft.EntityFrameworkCore;
using STEMMA.Domain.Consultas.Entities;
using STEMMA.Domain.Consultas.Repositories;
using STEMMA.Infrastructure.Persistence.Context;

namespace STEMMA.Infrastructure.Persistence.Repositories;

public class DisponibilidadeRepository : IDisponibilidadeRepository
{
    private readonly StemmaDbContext _context;

    public DisponibilidadeRepository(StemmaDbContext context)
    {
        _context = context;
    }

    public async Task AdicionarAsync(Disponibilidade disponibilidade)
    {
        await _context.Disponibilidades.AddAsync(disponibilidade);

        await _context.SaveChangesAsync();
    }

    public async Task AtualizarAsync(Disponibilidade disponibilidade)
    {
        _context.Disponibilidades.Update(disponibilidade);

        await _context.SaveChangesAsync();
    }

    public async Task RemoverAsync(Disponibilidade disponibilidade)
    {
        _context.Disponibilidades.Remove(disponibilidade);

        await _context.SaveChangesAsync();
    }

    public async Task<Disponibilidade?> ObterPorIdAsync(Guid id)
    {
        return await _context.Disponibilidades
            .Include(x => x.Veterinario)
            .FirstOrDefaultAsync(x => x.Id == id);
    }

    public async Task<List<Disponibilidade>> ListarAsync()
    {
        return await _context.Disponibilidades
            .Include(x => x.Veterinario)
            .AsNoTracking()
            .OrderBy(x => x.DataInicio)
            .ToListAsync();
    }

    public async Task<List<Disponibilidade>> ObterPorVeterinarioAsync(Guid veterinarioId)
    {
        return await _context.Disponibilidades
            .Where(x => x.VeterinarioId == veterinarioId)
            .AsNoTracking()
            .OrderBy(x => x.DataInicio)
            .ToListAsync();
    }

    public async Task<List<Disponibilidade>> ObterPorPeriodoAsync(
        Guid veterinarioId,
        DateTime inicio,
        DateTime fim)
    {
        return await _context.Disponibilidades
            .Where(x =>
                x.VeterinarioId == veterinarioId &&
                x.DataInicio < fim &&
                x.DataFim > inicio)
            .AsNoTracking()
            .ToListAsync();
    }

    public async Task<bool> ExisteConflitoAsync(
        Guid veterinarioId,
        DateTime inicio,
        DateTime fim)
    {
        return await _context.Disponibilidades
            .AnyAsync(x =>
                x.VeterinarioId == veterinarioId &&
                x.DataInicio < fim &&
                x.DataFim > inicio);
    }
}