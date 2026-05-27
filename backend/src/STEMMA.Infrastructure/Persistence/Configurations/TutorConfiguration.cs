using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

using STEMMA.Domain.Cadastro.Entities;

namespace STEMMA.Infrastructure.Persistence.Configurations;

public class TutorConfiguration : IEntityTypeConfiguration<Tutor>
{
    public void Configure(EntityTypeBuilder<Tutor> builder)
    {
        builder.ToTable("Tutores");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Nome)
            .IsRequired()
            .HasMaxLength(150);

        builder.Property(x => x.CPF)
            .IsRequired()
            .HasMaxLength(14);

        builder.Property(x => x.Email)
            .IsRequired()
            .HasMaxLength(150);

        builder.Property(x => x.DataCriacao)
            .IsRequired();

        builder.HasMany(x => x.Pets)
            .WithOne(x => x.Tutor)
            .HasForeignKey(x => x.TutorId);
    }
}