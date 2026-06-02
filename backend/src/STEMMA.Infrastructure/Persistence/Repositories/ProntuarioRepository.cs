using Microsoft.EntityFrameworkCore;
using STEMMA.Domain.Consultas.Entities;
using STEMMA.Domain.Consultas.Repositories;
using STEMMA.Infrastructure.Persistence.Context;

namespace STEMMA.Infrastructure.Persistence.Repositories;

public class ProntuarioRepository : IProntuarioRepository
{
    private readonly StemmaDbContext _context;

    public ProntuarioRepository(StemmaDbContext context)
    {
        _context = context;
    }

    public async Task AdicionarAsync(Prontuario prontuario)
    {
        await _context.Prontuarios.AddAsync(prontuario);

        await _context.SaveChangesAsync();
    }

    public async Task AtualizarAsync(Prontuario prontuario)
    {
        _context.Prontuarios.Update(prontuario);

        await _context.SaveChangesAsync();
    }

    public async Task<Prontuario?> ObterPorIdAsync(Guid id)
    {
        return await _context.Prontuarios
            .FirstOrDefaultAsync(x => x.Id == id);
    }

    public async Task<Prontuario?> ObterPorConsultaIdAsync(Guid consultaId)
    {
        return await _context.Prontuarios
            .FirstOrDefaultAsync(x => x.ConsultaId == consultaId);
    }

    public async Task<List<Prontuario>> ListarAsync()
    {
        return await _context.Prontuarios
            .AsNoTracking()
            .ToListAsync();
    }
}