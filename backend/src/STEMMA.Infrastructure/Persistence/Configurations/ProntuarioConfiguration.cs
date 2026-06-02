using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using STEMMA.Domain.Consultas.Entities;

namespace STEMMA.Infrastructure.Persistence.Configurations;

public class ProntuarioConfiguration
    : IEntityTypeConfiguration<Prontuario>
{
    public void Configure(EntityTypeBuilder<Prontuario> builder)
    {
        builder.ToTable("Prontuarios");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Observacoes)
            .IsRequired()
            .HasMaxLength(1000);

        builder.Property(x => x.Diagnostico)
            .IsRequired()
            .HasMaxLength(500);
    }
}