using Microsoft.EntityFrameworkCore;
using STEMMA.Domain.Consultas.Entities;
using STEMMA.Domain.Consultas.Enums;
using STEMMA.Domain.Consultas.Repositories;
using STEMMA.Infrastructure.Persistence.Context;

namespace STEMMA.Infrastructure.Persistence.Repositories;

public class ConsultaRepository : IConsultaRepository
{
    private readonly StemmaDbContext _context;

    public ConsultaRepository(StemmaDbContext context)
    {
        _context = context;
    }

    public async Task AdicionarAsync(Consulta consulta)
    {
        await _context.Consultas.AddAsync(consulta);
        await _context.SaveChangesAsync();
    }

    public async Task AtualizarAsync(Consulta consulta)
    {
        _context.Consultas.Update(consulta);
        await _context.SaveChangesAsync();
    }

    public async Task<Consulta?> ObterPorIdAsync(Guid id)
    {
        return await _context.Consultas
            .Include(x => x.Veterinario)
            .FirstOrDefaultAsync(x => x.Id == id);
    }

    public async Task<List<Consulta>> ListarAsync()
    {
        return await _context.Consultas
            .Include(x => x.Veterinario)
            .AsNoTracking()
            .ToListAsync();
    }

    public async Task<List<Consulta>> ObterPorVeterinarioAsync(Guid veterinarioId)
    {
        return await _context.Consultas
            .Where(x => x.VeterinarioId == veterinarioId)
            .AsNoTracking()
            .ToListAsync();
    }

    public async Task<List<Consulta>> ObterPorPetAsync(Guid petId)
    {
        return await _context.Consultas
            .Where(x => x.PetId == petId)
            .AsNoTracking()
            .ToListAsync();
    }

    public async Task<bool> ExisteConsultaNoHorarioAsync(
        Guid veterinarioId,
        DateTime dataConsulta)
    {
        return await _context.Consultas
            .AnyAsync(x =>
                x.VeterinarioId == veterinarioId &&
                x.DataConsulta == dataConsulta &&
                x.Status != StatusConsulta.Cancelada);
    }

    public async Task<List<Consulta>> ListarFuturasPorPetAsync(Guid petId)
    {
        return await _context.Consultas
            .Where(x =>
                x.PetId == petId &&
                x.Status == StatusConsulta.Agendada &&
                x.DataConsulta > DateTime.UtcNow)
            .ToListAsync();
    }

    public async Task<List<Consulta>> ObterPorVeterinarioEPeriodoAsync(
    Guid veterinarioId,
    DateTime inicio,
    DateTime fim)
    {
        return await _context.Consultas
            .Where(x =>
                x.VeterinarioId == veterinarioId &&
                x.DataConsulta >= inicio &&
                x.DataConsulta <= fim)
            .ToListAsync();
    }

    public async Task<List<Consulta>> ObterEncerradasAsync()
    {
        return await _context.Consultas
            .Where(x => x.Status == StatusConsulta.Encerrada)
            .ToListAsync();
    }
}