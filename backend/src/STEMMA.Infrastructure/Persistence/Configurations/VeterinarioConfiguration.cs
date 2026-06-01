using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using STEMMA.Domain.Cadastro.Entities;

namespace STEMMA.Infrastructure.Persistence.Configurations;

public class VeterinarioConfiguration
    : IEntityTypeConfiguration<Veterinario>
{
    public void Configure(
        EntityTypeBuilder<Veterinario> builder)
    {
        builder.ToTable("Veterinarios");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Nome)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(x => x.CRMV)
            .IsRequired()
            .HasMaxLength(30);

        builder.Property(x => x.Email)
            .IsRequired()
            .HasMaxLength(150);

        builder.Property(x => x.Senha)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(x => x.Especialidade)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(x => x.DataCriacao)
            .IsRequired();
    }
}