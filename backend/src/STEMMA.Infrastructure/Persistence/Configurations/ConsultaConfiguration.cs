using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using STEMMA.Domain.Consultas.Entities;

namespace STEMMA.Infrastructure.Persistence.Configurations;

public class ConsultaConfiguration : IEntityTypeConfiguration<Consulta>
{
    public void Configure(EntityTypeBuilder<Consulta> builder)
    {
        builder.ToTable("Consultas");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Veterinario)
            .IsRequired()
            .HasMaxLength(150);

        builder.Property(x => x.DataConsulta)
            .IsRequired();

        builder.Property(x => x.Encerrada)
            .IsRequired();
    }
}