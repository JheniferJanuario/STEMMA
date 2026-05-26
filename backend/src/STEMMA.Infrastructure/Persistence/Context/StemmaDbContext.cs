using Microsoft.EntityFrameworkCore;
using STEMMA.Domain.Cadastro.Entities;
using STEMMA.Domain.Consultas.Entities;

namespace STEMMA.Infrastructure.Persistence.Context;

public class StemmaDbContext : DbContext
{
    public StemmaDbContext(DbContextOptions<StemmaDbContext> options)
        : base(options)
    {
    }

    public DbSet<Tutor> Tutores { get; set; }

    public DbSet<Pet> Pets { get; set; }

    public DbSet<Consulta> Consultas { get; set; }

    public DbSet<Disponibilidade> Disponibilidades { get; set; }

    public DbSet<Prontuario> Prontuarios { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.ApplyConfigurationsFromAssembly(
            typeof(StemmaDbContext).Assembly);
    }
}