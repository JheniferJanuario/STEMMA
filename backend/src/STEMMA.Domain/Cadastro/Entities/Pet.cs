using STEMMA.Domain.Cadastro.Enums;

namespace STEMMA.Domain.Cadastro.Entities;

public class Pet
{
    public Guid Id { get; private set; }

    public string Nome { get; private set; }

    public string Raca { get; private set; }

    public int Idade { get; private set; }

    public decimal Peso { get; private set; }

    public StatusPet Status { get; private set; }

    public Guid TutorId { get; private set; }

    public Tutor Tutor { get; private set; }

    protected Pet() { }

    public Pet(
        string nome,
        string raca,
        int idade,
        decimal peso,
        Guid tutorId)
    {
        Validar(nome, raca, idade, peso, tutorId);

        Id = Guid.NewGuid();
        Nome = nome;
        Raca = raca;
        Idade = idade;
        Peso = peso;
        TutorId = tutorId;

        Status = StatusPet.Ativo;
    }

    public void AlterarPeso(decimal peso)
    {
        if (peso <= 0)
            throw new ArgumentException("Peso inválido.");

        Peso = peso;
    }

    public void AlterarStatus(StatusPet status)
    {
        Status = status;
    }

    private void Validar(
        string nome,
        string raca,
        int idade,
        decimal peso,
        Guid tutorId)
    {
        if (string.IsNullOrWhiteSpace(nome))
            throw new ArgumentException("Nome do pet obrigatório.");

        if (string.IsNullOrWhiteSpace(raca))
            throw new ArgumentException("Raça obrigatória.");

        if (idade < 0)
            throw new ArgumentException("Idade inválida.");

        if (peso <= 0)
            throw new ArgumentException("Peso inválido.");

        if (tutorId == Guid.Empty)
            throw new ArgumentException("Tutor obrigatório.");
    }
}