using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using STEMMA.Domain.Consultas.Entities;

namespace STEMMA.Infrastructure.Persistence.Configurations;

public class DisponibilidadeConfiguration : IEntityTypeConfiguration<Disponibilidade>
{
    public void Configure(EntityTypeBuilder<Disponibilidade> builder)
    {
        builder.ToTable("Disponibilidades");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.DataInicio)
            .IsRequired();

        builder.Property(x => x.DataFim)
            .IsRequired();

        builder.HasOne(x => x.Veterinario)
            .WithMany()
            .HasForeignKey(x => x.VeterinarioId);
    }
}