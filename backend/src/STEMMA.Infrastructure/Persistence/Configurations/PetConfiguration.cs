using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using STEMMA.Domain.Cadastro.Entities;

namespace STEMMA.Infrastructure.Persistence.Configurations;

public class PetConfiguration : IEntityTypeConfiguration<Pet>
{
    public void Configure(EntityTypeBuilder<Pet> builder)
    {
        builder.ToTable("Pets");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Nome)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(x => x.Raca)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(x => x.Idade)
            .IsRequired();

        builder.Property(x => x.Peso)
            .HasColumnType("decimal(10,2)");
    }
}