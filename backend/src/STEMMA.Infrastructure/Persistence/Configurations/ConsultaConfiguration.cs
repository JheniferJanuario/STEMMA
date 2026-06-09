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

        builder.Property(x => x.DataConsulta)
            .IsRequired();

        builder.Property(x => x.Status)
            .IsRequired();

        builder.HasOne(x => x.Veterinario)
            .WithMany()
            .HasForeignKey(x => x.VeterinarioId);

        builder.Property(x => x.PetId)
            .IsRequired();

        builder.HasIndex(x => new { x.VeterinarioId, x.DataConsulta })
       .IsUnique();
    }
}